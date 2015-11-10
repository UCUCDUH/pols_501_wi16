library("DiagrammeR")

grViz("
digraph {
  a [label=\"1. Ask a research question (research hypothesis)\"]
  b [label=\"2. Design a study and collect data\"]
  c [label=\"3. Explore the data\"]
  d [label=\"4. Draw inferences (significance, estimation)\"]
  e [label=\"5. Formulate conclusions (generalization, causation)\"]
  f [label=\"6. Look back and ahead\"]
  a -> b
  b -> c
  c -> d
  d -> e
  e -> f
  f -> a

}
")
