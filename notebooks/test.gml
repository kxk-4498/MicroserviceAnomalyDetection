graph [
  directed 1
  node [
    id 0
    label "world"
    size 10
  ]
  node [
    id 1
    label "front-end"
    size 10
  ]
  node [
    id 2
    label "kube-dns"
    size 10
  ]
  node [
    id 3
    label "user"
    size 10
  ]
  node [
    id 4
    label "session-db"
    size 10
  ]
  node [
    id 5
    label "user-db"
    size 10
  ]
  node [
    id 6
    label "catalogue"
    size 10
  ]
  node [
    id 7
    label "catalogue-db"
    size 10
  ]
  node [
    id 8
    label "carts"
    size 10
  ]
  node [
    id 9
    label "carts-db"
    size 10
  ]
  node [
    id 10
    label "queue-master"
    size 10
  ]
  node [
    id 11
    label "rabbitmq"
    size 10
  ]
  node [
    id 12
    label "orders"
    size 10
  ]
  node [
    id 13
    label "orders-db"
    size 10
  ]
  edge [
    source 0
    target 1
    weight 100.0
  ]
  edge [
    source 1
    target 2
    weight 120.0
  ]
  edge [
    source 1
    target 3
    weight 80.0
  ]
  edge [
    source 1
    target 4
    weight 2.0
  ]
  edge [
    source 1
    target 6
    weight 80.0
  ]
  edge [
    source 1
    target 0
    weight 80.0
  ]
  edge [
    source 2
    target 1
    weight 120.0
  ]
  edge [
    source 2
    target 6
    weight 8.0
  ]
  edge [
    source 2
    target 8
    weight 1.0
  ]
  edge [
    source 2
    target 3
    weight 4.0
  ]
  edge [
    source 2
    target 12
    weight 1.0
  ]
  edge [
    source 3
    target 1
    weight 60.0
  ]
  edge [
    source 3
    target 5
    weight 19.0
  ]
  edge [
    source 3
    target 2
    weight 4.0
  ]
  edge [
    source 4
    target 1
    weight 2.0
  ]
  edge [
    source 5
    target 3
    weight 19.0
  ]
  edge [
    source 6
    target 1
    weight 60.0
  ]
  edge [
    source 6
    target 7
    weight 27.0
  ]
  edge [
    source 6
    target 2
    weight 8.0
  ]
  edge [
    source 7
    target 6
    weight 17.0
  ]
  edge [
    source 8
    target 2
    weight 1.0
  ]
  edge [
    source 8
    target 9
    weight 6.0
  ]
  edge [
    source 9
    target 8
    weight 5.0
  ]
  edge [
    source 10
    target 11
    weight 3.0
  ]
  edge [
    source 11
    target 10
    weight 3.0
  ]
  edge [
    source 12
    target 2
    weight 1.0
  ]
  edge [
    source 12
    target 13
    weight 3.0
  ]
  edge [
    source 13
    target 12
    weight 2.0
  ]
]
