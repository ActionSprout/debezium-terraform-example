Example Terraform setup for debezium


Getting Started
---

To run this example:

1. Edit or copy example.env

   * Set `TF_VAR_do_token` by replacing `abcdef` with a Digital Ocean API token
   * Feel free to change `TF_VAR_do_public_key` and `TF_VAR_do_private_key`,
     but what's there should work if you have an rsa ssh key set up.

2. Source your env file (`source example.env`)
3. Run `terraform apply` and wait for it to complete
4. Run `bin/watch.sh` in one terminal
5. In another terminal run some postgres updates, for example:

   ```
   bin/run-query.sh "INSERT INTO PEOPLE (email, name) VALUES ('test@example.com', 'Testing Tester');"
   bin/run-query.sh "DELETE FROM PEOPLE;"
   ```

