defmodule Ficdb.Image do
  use Arc.Definition

  # Include ecto support (requires package arc_ecto installed):
   use Arc.Ecto.Definition

  # To add a thumbnail version:
   @versions [:thumb]

  # Override the bucket on a per definition basis:
  # def bucket do
  #   :custom_bucket_name
  # end

  # Whitelist file extensions:
   def validate({file, _}) do
     ~w(.jpg .jpeg .gif .png .JPG .JPEG .GIF .PNG) |> Enum.member?(Path.extname(file.file_name))
   end

  # Define a thumbnail transformation:
   def transform(:thumb, _) do
     {:convert, "-strip -thumbnail 100x100^ -gravity center -extent 100x100 -format png", :png}
   end

   # Override the persisted filenames:
#   def filename(version, {file, scope}) do
#      file_name = Path.basename(file.file_name, Path.extname(file.file_name))
#      DateTime.utc_now
#      |> DateTime.to_unix
#      |> Integer.to_string
#      |> Kernel.<>(file_name)
#   end

  # Override the storage directory:
#   def storage_dir(version, {file, scope}) do
#     "uploads/user/avatars/#{scope.id}"
#   end

  # Provide a default URL if there hasn't been a file uploaded
   def default_url(version, scope) do
     "/images/logo_only.svg"
   end

#  def storage_dir(_, {file, scope}) do
#    schema = scope.__struct__  |> Kernel.inspect |> String.split(".") |> List.last |> String.downcase
#    "uploads/arc/#{schema}-#{scope.id}"
#  end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  # def s3_object_headers(version, {file, scope}) do
  #   [content_type: MIME.from_path(file.file_name)]
  # end
end
