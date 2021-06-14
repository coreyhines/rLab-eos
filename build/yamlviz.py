#!/usr/bin/env python3
from graphviz import Digraph
import json
from os import getcwd
from ruamel.yaml import YAML
import argparse

BASE_PATH = getcwd()

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


def create_topo(root, neigh_list):
    nodes = []
    edges = []
    dev_links = []
    for _node in neigh_list:
        nodes.append(_node['name'])
        for _neigh in _node['neighbors']:
            _local = _node['name'] + _neigh['port']
            _remote = _neigh['neighborDevice'] + _neigh['neighborPort']
            if not checkedge_exist(_local, _remote, dev_links):
                edges.append([_node['name'], _neigh['neighborDevice'], _neigh['neighborPort'] + "-" + _neigh['port']])
                dev_links.append(_local + "-" + _remote)
        #edges.append([root, neighbor['neighborDevice'], neighbor['neighborPort'] + "-" + neighbor['port'] ])
    return [nodes, edges]

def make_topology(network_name, mytopo):
    dot = Digraph(comment=network_name, format='png')
    #dot.graph_attr['splines'] = "ortho"
    dot.attr('node', shape='box')
    #dot.attr('node', image="./images/switch1.png")
    #dot.attr('node', image="./images/image.png")
    dot.attr('edge', weight='10')
    dot.attr('edge', arrowhead='none')
    #dot.body.append(r'label = "\n\nMy Prettier Network Diagram w/ straight edges"')
    dot.body.append('fontsize=20')
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

    dot = make_topology("My New Network", my_topo)
    dot.render(filename=args.topo, directory=BASE_PATH + "/topologies", cleanup=True)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-t", "--topo", type=str, help="Topology diagram to build", default=None, required=True)
    args = parser.parse_args()
    main(args)