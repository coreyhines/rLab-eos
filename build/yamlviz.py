#!/usr/bin/env python3
from graphviz import Digraph
import json
from os import getcwd
from ruamel.yaml import YAML
import argparse

BASE_PATH = getcwd()
looped = []
dooped = []

def openTopo(topo):
    try:
        tmp_topo = open(BASE_PATH + "/topologies/{}.yaml".format(topo), 'r')
        #tmp_topo = open(yaml_file, 'r')
        tmp_yaml = YAML().load(tmp_topo)
        tmp_topo.close()
        return(tmp_yaml)
    except:
        return(False)


def checkedge_exist(_local, _remote, dev_links):
    for _link in dev_links:
        if _local in _link and _remote in _link:
            return True
    return False

def checkedge_loop(_local, _remote):
    if _local == _remote:
        return True
    return False

def checkedge_reused_remote(_remote, _remote_seen):
    if _remote in _remote_seen:
        return True
    return False

def create_topo(root, neigh_list):
    nodes = []
    edges = []
    remotes_seen = []
    dev_links = []
    for _node in neigh_list:
        nodes.append(_node['name'])
        for _neigh in _node['neighbors']:
            _local = _node['name'] + _neigh['port']
            _remote = _neigh['neighborDevice'] + _neigh['neighborPort']
            if checkedge_loop(_node['name'], _neigh['neighborDevice']):
                global looped
                looped.append(_node['name'])
            else:
                loop = False
            if checkedge_reused_remote(_remote, remotes_seen):
                global dooped
                dooped.append([_node['name'], _remote])
                print (f'iBerg! {_remote}')
            if not checkedge_exist(_local, _remote, dev_links):
                edges.append([_node['name'], _neigh['neighborDevice'], _neigh['neighborPort'] + "-" + _neigh['port']])
                dev_links.append(_local + "-" + _remote)
                remotes_seen.append(_remote)
    return [nodes, edges]

def make_topology(network_name, mytopo):
    dot = Digraph(comment=network_name, format='png')
    #dot.graph_attr['splines'] = "ortho"
    dot.attr('node', shape='none', overlap='false', fontsize='55', fontcolor='black', labelloc='b')
    dot.attr('node', image=BASE_PATH + "/images/switch.png")
    dot.attr('edge', penwidth='2')
    dot.attr('edge', arrowhead='none')
    if looped:
        dot.body.append(rf'label = "\n\n Looped connection ALERT!\nCHECK YOUR TOPO YAML.\nNode: {looped} is connected to itself"')
    if dooped:
        dot.body.append(rf'label = "\n\n Duped connection ALERT!\nCHECK YOUR TOPO YAML.\nNode: {dooped} are being reused"')

    dot.body.append('fontsize=40')
    dot.engine = 'fdp'
    for i in mytopo[0]:
        dot.node(i)
    for i in mytopo[1]:
        dot.edge(i[0], i[1])
    return dot


def main(args):
    topo = openTopo(args.topo)
    nodes = []
    for node in topo['nodes']:
        nodes.append({'name': node, 'neighbors': topo['nodes'][node]['neighbors']})

    my_topo = create_topo(topo['topology']['name'], nodes)
    dot = Digraph(comment='My Network')

    dot = make_topology(topo['topology']['name'], my_topo)
    dot.render(filename=args.topo, directory=BASE_PATH + "/topologies", cleanup=True)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-t", "--topo", type=str, help="Topology diagram to build", default=None, required=True)
    args = parser.parse_args()
    main(args)