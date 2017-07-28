# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Dresstillery.Repo.insert!(%Dresstillery.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

permissions = Dresstillery.Administration.BackofficePermissions.all
|> Enum.map(& %Dresstillery.Administration.Permission{name: &1})

# Comeonin.Bcrypt.hashpwsalt("p@ssw0rd")
%Dresstillery.Administration.BackofficeUser{login: "admin", password: "$2b$12$R3nBGCoa53vS4M1XgBpTgu7LROinWVaYEhKLG0Xo77Nghx1DtRVu."}
|> Ecto.Changeset.change()
|> Ecto.Changeset.put_embed(:permissions, permissions)
|> Dresstillery.Repo.insert!
