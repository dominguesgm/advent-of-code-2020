# Kotlin

More about the problem than the language, this was a huge headache.

Initially it didn't work because Int's are too small, and then because Long's also were to small. This is why I ended up using BigInteger.

The `normalizeVal` function, used to determine the lowest positive value for `y` in `a*x + b = y`, with `a` being the result of `n1*n2*n3*...n` and `b` the result of the `existenceProof`, was the biggest bottleneck by the end for stupid reasons. I was looping, adding/subtracting `a` until I found the lowest positive `y`, which was extremely inneficient when `a` and `b` had very different orders of magnitude. By the end I had the idea of estimating `x` first, which would lead to only having to step once in one direction to find the lowest positive `y` value (I'm not proud it took me that long to decide on this approach).

Other than that, this was the algorithm description found on the wikipedia page for the Chinese Remainder Theorem, with the use Bernout Identity (which was the only piece of algorithm pseudo code I actually had to read to implement).

Thankfully, despite being my first time with kotlin, it didn't pose that much of a bottleneck for getting to the solution. Interop with java gives plenty of freedom (thank god I could use BigIntegers). It could use some automatic typecasting when making calculations (too many `toBigInteger` in my code), but other than that I liked it. Syntax-wise it felt like using javascript-flavoured java.