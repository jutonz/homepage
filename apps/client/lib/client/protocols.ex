require Protocol

Protocol.derive(Jason.Encoder, Money, only: [:amount, :currency])
