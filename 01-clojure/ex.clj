(defn sumIsCorrect2 [total value1 value2] 
    (= total (+ value1 value2)))

(defn innerLoop [total base data] 
    (loop [tempVec data]
        (if (empty? tempVec)
            false
            (if (sumIsCorrect2 total base (first tempVec))
                (first tempVec)
                (recur (rest tempVec))))))

(defn outerLoop [total data] 
    (loop [tempVec data]
        (let [res (innerLoop total (first tempVec) (rest tempVec))]
            (if (not= res false)
                (* res (first tempVec))
                (recur (rest tempVec))))))

(defn readData []
    (with-open [rdr (clojure.java.io/reader "data.txt")]
    (reduce conj [] (line-seq rdr))))

(defn parseInt [val] (Integer/parseInt val))

(defn getNums [data] (map parseInt data))

(println (outerLoop 2020 (getNums (readData))))

(defn sumIsCorrect2 [total value1 value2 value3] 
    (= total (+ value1 value2 value3)))

(defn innerLoop2 [total base1 base2 data] 
    (loop [tempVec data]
        (if (empty? tempVec)
            false
            (if (sumIsCorrect2 total base1 base2 (first tempVec))
                (first tempVec)
                (recur (rest tempVec))))))

(defn middleLoop2 [total base1 data] 
    (loop [tempVec data]
        (if (empty? tempVec)
            false
            (let [res (innerLoop2 total base1 (first tempVec) (rest tempVec))]
                (if (not= res false)
                    (* res (first tempVec))
                    (recur (rest tempVec)))))))

(defn outerLoop2 [total data] 
    (loop [tempVec data]
        (let [res (middleLoop2 total (first tempVec) (rest tempVec))]
            (if (not= res false)
                (* res (first tempVec))
                (recur (rest tempVec))))))

(println (outerLoop2 2020 (getNums (readData))))