Portraits of Complex Networks
=============================

Abstract 
--------

We propose a method for characterizing large complex networks by introducing a
new matrix structure, unique for a given network, which encodes structural
information; provides useful visualization, even for very large networks; and
allows for rigorous statistical comparison between networks. Dynamic processes
such as percolation can be visualized using animation.

* [Journal Page](http://dx.doi.org/10.1209/0295-5075/81/68004)
* [arXiv preprint](http://arxiv.org/abs/cond-mat/0703470)
* [Additional matrices and animations](http://people.clarkson.edu/~dbenavra/B_matrix_site/).


About the code
--------------

`B_matrix.py` and `B_matrix.cpp` take an edgelist file and write the
corresponding *B*-matrix to a file

An edgelist is an *M* x 2 matrix for a graph with *M* edges. The C++ code
requires nodes be sequential integers numbered from zero, while the python code
is slower, but much more flexible (can handle directed networks for example,
which the C++ cannot) and forgiving. Python code requires [networkx] and
(optionally) [pylab] to plot.

Unless the networks are very large, I greatly encourage using the python code
instead of the C++.  Additionally, networkx has undergone a great deal of
updates and the `B_matrices.py` file might be slightly out of date, requiring
small changes to work again.  Fair warning, buyer beware, etc.

Various matlab m-files are included for loading a *B*-matrix from file,
trimming empty columns, and computing the distance between two matrices. The
latter is accomplished using `B_Distance.m`, which takes two matrices as input
and returns the distance as described in the paper. It will optionally also
plot the row-wise distances.

The m-files may also work in [octave], an open source "clone" of matlab but I
haven't tried so I make no guarantees.

- Jim Bagrow, 2008-04-17
- bagrowjp [at] gmail [dot] com


[networkx]: http://networkx.lanl.gov/
[pylab]: http://matplotlib.org
[octave]: http://www.gnu.org/software/octave/

