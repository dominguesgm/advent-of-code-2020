# Julia

Really enjoyed working with this language. It has some interesting ideas and some things we find in some programming languages like pipe operators, function composition (which I sadly didn't use).

It provides some features to make it easy to define lambdas when using `mapreduce`, for example (the `do` keyword). One thing I'm not sure I like is that these collection operations, more specifically `reduce` and `mapreduce` cause some confusion: `reduce` only takes a binary operator and not a lambda, if you want to achieve the behavior you find in other languages, you have to use `mapreduce`, provide a lambda, and then provide and operator to combine the accumulator and the result.

In a few words, very similar to python but in exchange for using `&&` and `||` again, I have to start counting arrays with 1. I didn't get to explore this part too much, but it seems to have native support for multi dimentional arrays with their own accessors (`[x, y]`) as well as their own iterating functions (`eachindex`).

The exercise itself was easy and julia didn't feel like a blocker for the type of problem we had to solve. I went with switching between two matrixes (even though I have to rewrite it all each time) because I assume the memory allocation process for the matrix must cause some overhead.