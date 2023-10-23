defmodule RequestIdGenerator do
  def generate_request_id do
    random_bytes = :crypto.strong_rand_bytes(16)
    request_id = Base.encode16(random_bytes, case: :lower)
    "req-#{request_id}"
  end
end
