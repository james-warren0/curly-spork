# output "pet_id" {
#   value = random_pet.server.id
# }

output "my_env" {
  value = data.external.env.result
}