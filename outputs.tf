output "pet_id" {
  value = random_pet.server.id
}

# output "db" {
#   value     = random_pet.database.keepers.foo
#   sensitive = true
# }

# output "my_env" {
#   value = data.external.env.result
# }
