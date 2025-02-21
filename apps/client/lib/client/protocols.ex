require Protocol

Protocol.derive(JSON.Encoder, Money, only: [:amount, :currency])
