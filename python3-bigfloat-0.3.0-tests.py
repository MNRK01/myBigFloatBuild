# tests from https://pythonhosted.org/bigfloat/index.html
# copy, paste into ipython and execute. Values checked to be correct on 11/22/2018.

from bigfloat import *
print(sqrt(2, precision(100)))          # compute sqrt(2) with 100 bits of precision
# 1.4142135623730950488016887242092
with precision(100):                    # another way to get the same result
    print(sqrt(2))
# 1.4142135623730950488016887242092

my_context = precision(100) + RoundTowardPositive
print(my_context)
# Context(precision=100, rounding=ROUND_TOWARD_POSITIVE)
print(sqrt(2, my_context))              # and another, this time rounding up
# 1.4142135623730950488016887242108

with RoundTowardNegative:               # a lower bound for zeta(2)
    print(sum(1/sqr(n) for n in range(1, 10000)))
# 1.6448340618469506
print(zeta(2))                          # actual value, for comparison
# 1.6449340668482264
print(const_pi()**2/6.0)                # double check value
# 1.6449340668482264

quadruple_precision                     # context implementing IEEE 754 binary128 format
print(next_up(0, quadruple_precision))  # smallest subnormal for binary128
# 6.47517511943802511092443895822764655e-4966
print(log2(next_up(0, quadruple_precision)))
# -16494.000000000000

