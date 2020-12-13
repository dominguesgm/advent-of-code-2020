# Haskell

## Thoughts

Part two of this day was rather complicated. I spent a while trying to come up with a solution to this problem.

I found out later I could use tribonacci to work out an efficient (O(n)) solution to this problem. However, since I didn't come up with that solution by myself, I chose to follow the line of thought I was trying before I found this.

The solution I came up with is a recursive approach with the use of memoization. At first glance this may seem terrible due to the huge number of combinations possible with the dataset. To avoid, or at lease minimize the effects of this complexity I start by computing the differences in `jolts` between each adapter (sorted) and split that list by difference of `3`.

After splitting, I filter out every list that cannot be reduced (size 1 or 0). I then run `checkCombinations` for each list os 1/2s and multiply all the results of all the possible number of combinations of each list. Working on smaller lists improves the performance right away, and the extra performance bump is achieved with memoization in a map that is persisted and updated when being passed to each new call of `checkCombinations`, as well as being maintained in the `foldl` accumulator.

One possible performance drawback of the language choice: haskell is rather weak at handling maps, or hashed collections (though it has the advantage that a list can be a key of the map without list identity issues), as it has complexity O(logn) rather than O(1). Another problem with the approach is the number of combinations that can end up in the map. It can therefore be a rather memory intensive solution if we're facing long lists, especially if randomly interspersed with 2's and not just 1's.

Speaking of which, the dataset conviniently was laking any `jolt` gaps of 2. I honestly don't know how interspersed 2 jolt intervals would have impacted the tribonacci solution, I still haven't thought about it thoroughly. I am, however, really confident that despite it's shortcomings this solution would handle that kind of differences correctly, even if at the cost of even more combinations in the map.


NOTE: I'll leave the debugging code to improve comprehensibility when checking out this solution

