# xsp
This package provides statistics to test periodicity of time series data using Chi-square periodogram (Sokolove, *J Theor Biol*., 1978). The Qp is calculated by following formula,

<a href="https://www.codecogs.com/eqnedit.php?latex=Q_{P=}\frac{KN{\displaystyle\sum_{h=1}^P}({\overline&space;y}_h-\overline&space;y)^2}{{\displaystyle\sum_{i=1}^N}(y_i-\overline&space;y)^2}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?Q_{P=}\frac{KN{\displaystyle\sum_{h=1}^P}({\overline&space;y}_h-\overline&space;y)^2}{{\displaystyle\sum_{i=1}^N}(y_i-\overline&space;y)^2}" title="Q_{P=}\frac{KN{\displaystyle\sum_{h=1}^P}({\overline y}_h-\overline y)^2}{{\displaystyle\sum_{i=1}^N}(y_i-\overline y)^2}" /></a>

where *P* is the period of samples, *y̅<sub>h</sub>* are the means of column after arranging the series (of *N* elements) in an array of *P* columns, and *K* is the row number of the resulting array. *Q<sub>P</sub>* follows a chi-square distribution with as many degrees as cycles in each section. 

![Rplot.pdf](https://github.com/hiuchi/xsp/files/2108747/Rplot.pdf)

![xsp](https://github.com/hiuchi/xsp/files/2108747/Rplot.pdf)
