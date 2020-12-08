#! /usr/bin/gst -f

Object subclass: Bag [
    | name belongsTo contains |
    Bag class >> new [
        | r |
        r := super new.
        r init.
        ^r
    ]

    init [
        belongsTo := Dictionary new.
        contains := Dictionary new.
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

    contains [
        ^contains
    ]

    directlyContainedIn: bag times: number [
        belongsTo at: bag put: number.
    ]

    directlyContains: bag times: number [
        contains at: bag put: number.
    ]

    totalBagCount [
        | tempCount |
        tempCount := 0.

        contains keysAndValuesDo: [ :key :value |
            | keyCount totalKeyBags |
            keyCount := key auxTotalBagCount.
            totalKeyBags := value * keyCount.
            tempCount := tempCount + totalKeyBags.
        ].

        ^tempCount
    ]

    auxTotalBagCount [
        | tempCount |
        tempCount := 1.

        contains keysAndValuesDo: [ :key :value |
            | keyCount totalKeyBags |
            keyCount := key auxTotalBagCount.
            totalKeyBags := value * keyCount.
            tempCount := tempCount + totalKeyBags.
        ].

        ^tempCount
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
    splitFirstBagArray := c tokenize: ' bags contain( )?'.
    sourceBag := splitFirstBagArray first.

    bagFromDict := bagsContaining at: sourceBag ifAbsentPut: [
        Bag new.
    ].

    bagFromDict name: sourceBag.

    (splitFirstBagArray size > 1) ifTrue: [
        splitContainedBags := (splitFirstBagArray at: 2) tokenize: ' bag[s]?(, )?[.]?'.

        splitContainedBags do: [ :item |
            (item = 'no other') ifFalse: [
                bagCount := ((item tokenize: ' ') first) asNumber.
                bagName := (item tokenize: '[\d]+ ') second.

                containedBagFromDict := bagsContaining at: bagName ifAbsentPut: [
                    Bag new.
                ].

                containedBagFromDict name: bagName.

                bagFromDict directlyContains: containedBagFromDict times: bagCount.
                containedBagFromDict directlyContainedIn: bagFromDict times: bagCount.

            ].

        ].
    ].
].

file close.

((bagsContaining at: 'shiny gold') totalBagCount) displayNl.
