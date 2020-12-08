#! /usr/bin/gst -f

Object subclass: Bag [
    | name belongsTo |
    Bag class >> new [
        | r |
        r := super new.
        r init.
        ^r
    ]

    init [
        belongsTo := Set new.
    ]

    name: value [
        name := value
    ]

    name [
        ^name
    ]

    belongsTo [
        ^belongsTo
    ]

    directlyContainedIn: bag [
        belongsTo add: bag.
    ]

    fitsIn [
        | tempSet |
        tempSet := belongsTo deepCopy.

        belongsTo do: [ :item |
            tempSet addAll: (item fitsIn).
        ].

        ^tempSet
    ]

    printOn: stream [
        super printOn: stream.
        stream nextPutAll: ' with color: '.
        name printOn: stream.
    ]
].

bagsContaining := Dictionary new.

file := FileStream open: 'data.txt' mode: FileStream read.
file linesDo: [ :c |
    splitFirstBagArray := c tokenize: ' bags contain( [\d]* )?'.
    containingBag := splitFirstBagArray first.

    bagFromDict := bagsContaining at: containingBag ifAbsentPut: [
        Bag new.
    ].

    bagFromDict name: containingBag.

    (splitFirstBagArray size > 1) ifTrue: [
        splitContainedBags := (splitFirstBagArray at: 2) tokenize: ' bag[s]?(, [\d]+ )?[.]?'.

        splitContainedBags do: [ :item |
            containedBagFromDict := bagsContaining at: item ifAbsentPut: [
                Bag new.
            ].

            containedBagFromDict directlyContainedIn: bagFromDict.
        ].
    ].
].

file close.

(((bagsContaining at: 'shiny gold') fitsIn) size) displayNl.
((bagsContaining at: 'shiny gold') fitsIn) displayNl.


"MISSING GOING THROUGH THE DICTIONARY, FIND THE BAG, GO THROUGH SET AND REPEAT THIS PROCESS FOR EVERY ITEM IN SET, PLACING RESULTS IN A SET AND ONLY THEN COUNTING ELEMENTS IN THE SET"

