# Example Terraform setup for Debezium

## Getting Started

To run this example:

1. Edit or copy example.env

   * Set `TF_VAR_do_token` by replacing `abcdef` with a [Digital Ocean API token](https://cloud.digitalocean.com/account/api/tokens).
   * Feel free to change `TF_VAR_do_public_key` and `TF_VAR_do_private_key`,
     but what's there should work if you have an rsa ssh key set up.

2. Source your env file: `source example.env`. (If you're using oh-my-zsh, [there's a plugin for that](https://github.com/Schoonology/userenv-zsh).)
3. Run `terraform init` to initialize the plugins first.
4. Run `terraform apply` to create the infrastructure, and you've got Debezium set up!
5. Run `bin/watch.sh` in one terminal
6. In another terminal run some postgres updates, for example:

   ```sh
   bin/run-query.sh "INSERT INTO PEOPLE (email, name) VALUES ('test@example.com', 'Testing Tester');"
   bin/run-query.sh "DELETE FROM PEOPLE;"
   ```
