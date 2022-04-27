# defmodule SundialWeb.LabelController do
#   use SundialWeb, :controller

#   alias Sundial.Labels
#   alias Sundial.Labels.Label

#   def index(conn, _params) do
#     labels = Labels.list_labels()
#     render(conn, "index.html", labels: labels)
#   end

#   def new(conn, _params) do
#     labels = Labels.list_labels()
#     changeset = Labels.change_label(%Label{})

#     render(conn, "new.html", changeset: changeset, labels: labels)
#   end

#   def create(conn, %{"label" => label_params}) do
#     case Labels.create_label(label_params) do
#       {:ok, label} ->
#         conn
#         |> put_flash(:info, "Label created successfully.")
#         |> redirect(to: Routes.label_path(conn, :show, label))

#       {:error, %Ecto.Changeset{} = changeset} ->
#         render(conn, "new.html", changeset: changeset)
#     end
#   end

#   def show(conn, %{"id" => id}) do
#     label = Labels.get_label!(id)
#     render(conn, "show.html", label: label)
#   end

#   def edit(conn, %{"id" => id}) do
#     label = Labels.get_label!(id)
#     changeset = Labels.change_label(label)
#     render(conn, "edit.html", label: label, changeset: changeset)
#   end

#   def update(conn, %{"id" => id, "label" => label_params}) do
#     label = Labels.get_label!(id)

#     case Labels.update_label(label, label_params) do
#       {:ok, label} ->
#         conn
#         |> put_flash(:info, "Label updated successfully.")
#         |> redirect(to: Routes.label_path(conn, :show, label))

#       {:error, %Ecto.Changeset{} = changeset} ->
#         render(conn, "edit.html", label: label, changeset: changeset)
#     end
#   end

#   def delete(conn, %{"id" => id}) do
#     label = Labels.get_label!(id)
#     {:ok, _label} = Labels.delete_label(label)

#     conn
#     |> put_flash(:info, "Label deleted successfully.")
#     |> redirect(to: Routes.label_path(conn, :index))
#   end
# end
