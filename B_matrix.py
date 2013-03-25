#!/usr/bin/env python
# encoding: utf-8

# B_matrix.py
# Jim Bagrow 
# Last Modified: 2008-04-21

"""B_matrix.py - Calculates complex network portraits

COPYRIGHT:
    Copyright (C) 2008 Jim Bagrow
    
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
    
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    
    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
    
    See http://www.gnu.org/licenses/gpl.txt for more details.

ABOUT:
    Plot complex networks portraits, requires python 2.4 (I think?),
    networkx, and (optionally) matplotlib/pylab for plotting
    
    If this software is used in an article, an acknowledgment would be 
    awesome, as would an email with the article.  Please cite as:
    J. P. Bagrow et al 2008 EPL 81 68004
    
    Dependencies:
    http://www.python.org/
    https://networkx.lanl.gov/
    http://matplotlib.sourceforge.net/
    
    References:
    doi: 10.1209/0295-5075/81/68004
    http://arxiv.org/abs/cond-mat/0703470v2
    http://people.clarkson.edu/~qd00/B_matrix_site/

USAGE:
    python B_matrix.py input_edgelist.txt output_matrix.txt

Jim Bagrow, 2008-04-21
bagrowjp [at] gmail [dot] com
"""

import sys, os, networkx
from math import log
try:
	import numpy
except:
	import scipy_base as numpy

def elementWiseLog(mat):
	""" Take log of each element+1 in matrix, the +1
	keeps 0 from being a problem.  
	"""
	new_mat = zeros( mat.shape, tCode=float )
	i = 0
	for row in mat:
		j = 0
		for e in row:
			if e !=0:
				new_mat[i,j] = log( e+1 )
			else:
				new_mat[i,j] = 0
			j += 1
		i += 1
	return new_mat


def zeros( shape, tCode=None):
	try:
		return numpy.zeros(shape,dtype=tCode)
	except TypeError:
		return numpy.zeros(shape,typecode='fd') # hardwired to float


def fileMat(fileName, S=None):
	"""Read and write matrices to file at fileName
	if S=None, read S from fileName else write S.
	"""
	if S != None:
		f = open(fileName, 'w')
		for row in S:
			for el in row:
				print >>f, el,
			print >>f
		f.close()
	else:
		f = open(fileName, 'r')
		S = []
		for row in f.readlines():
			S.append( [float(i) for i in row.split(" ")] )
		return numpy.array(S)

def plotMatrix(o_mat, **kwargs):
	""" DOC STRING
	"""
	kwargs['interpolation']='nearest'
	origin = kwargs.get('origin',1); kwargs['origin']='lower'
	showColorBar = kwargs.get('showColorBar',False)
	if kwargs.has_key("showColorBar"): kwargs.pop("showColorBar")
	logColors    = kwargs.get('logColors',False)
	if kwargs.has_key("logColors"):    kwargs.pop("logColors")
	ifShow       = kwargs.get('show',False)
	if kwargs.has_key("show"):         kwargs.pop("show")
	fileName     = kwargs.get('fileName',None)
	if kwargs.has_key("fileName"):     kwargs.pop("fileName")

	mat = o_mat.copy() # don't modify original matrix
	if logColors: mat = elementWiseLog(mat)

	if not kwargs.has_key("vmax"):
		kwargs['vmax'] = float(mat[origin:,origin:].max())

	ax = pylab.axes()#[.05,.05,.9,.9])
	ax.xaxis.tick_top()
	H = pylab.imshow( mat, **kwargs)
	pylab.axis('tight')	
	ax.set_xlim( (origin,mat.shape[1]) )
	ax.set_ylim( (mat.shape[0],origin) )

	if showColorBar: pylab.colorbar()

	if fileName != None:
		pylab.savefig(fileName)

	if ifShow: pylab.show()
	else: pylab.draw_if_interactive()

	return H

def portrait(G):
	""" return matrix where M[i][j] is the number of starting nodes in G
	with j nodes in shell i.
	"""
	dia = 500 #networkx.diameter(G)
	N = G.number_of_nodes()
	# B indices are 0...dia x 0...N-1:
	B = zeros( (dia+1,N) ) 
	
	max_path = 1
	adj = G.adj
	for starting_node in G.nodes():
		nodes_visited = {starting_node:0}
		search_queue = [starting_node]
		d = 1
		while len(search_queue) > 0:
			next_depth = []
			extend = next_depth.extend
			for n in search_queue:
				l = [ i for i in adj[n].iterkeys() if i not in nodes_visited ] 
				extend(l)
				for j in l: # faster way?
					nodes_visited[j] = d
			search_queue = next_depth
			d += 1
		
		node_distances = nodes_visited.values()
		max_node_distances = max(node_distances)
		
		curr_max_path = max_node_distances
		if curr_max_path > max_path:
			max_path = curr_max_path
		
		# build individual distribution:
		dict_distribution = dict.fromkeys(node_distances, 0)
		for d in node_distances:
			dict_distribution[d] += 1
		# add individual distribution to matrix:
		for shell,count in dict_distribution.iteritems():
			B[shell][count] += 1
		
		# HACK: count starting nodes that have zero nodes in farther shells
		max_shell = dia
		while max_shell > max_node_distances:
			B[max_shell][0] += 1
			max_shell -= 1
	
	return B[:max_path+1,:]


if __name__ == '__main__':
	try:
		G = networkx.read_edgelist(sys.argv[1]) #, delimiter="\t")
	except:
		G = networkx.grid_2d_graph(20,20)
	
	B = portrait(G)
	
	try: # plot the portrait with pylab, but I prefer matlab:
		import pylab
		plotMatrix(B, origin=1, logColors=True, show=True)
	except ImportError:
		print "pylab failed, no plotting"
	try: 
		print "writing matrix to file...", sys.argv[2]
		fileMat(sys.argv[2], B)
	except:
		pass
