package main
resource_types = {"null_resource"}
resources[resource_type] = all {
    some resource_type
    resource_types[resource_type]
    all := [name |
        name:= input.resource_changes[_]
        name.type == resource_type
    ]
}
num_creates[resource_type] = num {
    some resource_type
    resource_types[resource_type]
    all := resources[resource_type]
    creates := [res |  res:= all[_]; res.change.actions[_] == "create"]
    num := count(creates)
}
deny[msg] {
    num_resources := num_creates["null_resource"]
    num_resources > 0
    msg := "Resource 'null_resource' detected in Terraform plan file. Denied."
}
