(ns build
  (:require [clojure.tools.build.api :as b]
            [com.biffweb :as biff]
            [com.biffweb.examples.docker :as main]))

(def main-ns 'com.biffweb.examples.docker)
(def class-dir "target/jar/classes")
(def basis (b/create-basis {:project "deps.edn"}))
(def uber-file "target/jar/app.jar")

(defn uberjar [_]
  (b/delete {:path "target"})
  (println (biff/sh "bb" "css" "--minify"))
  (main/generate-assets! {})
  (b/copy-dir {:src-dirs ["src" "resources" "target/resources"]
               :target-dir class-dir})
  (println "Compiling...")
  (b/compile-clj {:basis basis
                  :ns-compile [main-ns]
                  :class-dir class-dir})
  (println "Building uberjar...")
  (b/uber {:class-dir class-dir
           :uber-file uber-file
           :basis basis
           :main main-ns}))
