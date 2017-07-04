use v6;
use Finance::GDAX::API::TypeConstraints;
use Finance::GDAX::API;

class Finance::GDAX::API::Deposit does Finance::GDAX::API
{
    has             $.payment-method-id   is rw;
    has             $.coinbase-account-id is rw;
    has PositiveNum $.amount              is rw is required;
    has             $.currency            is rw is required;;

    method from-payment() {
	fail 'payments need a payment id set' unless $.payment-method-id;
	$.path   = 'deposits/payment-method';
	$.method = 'POST';
	$.body   = { amount            => $.amount,
		     currency          => $.currency,
		     payment_method_id => $.payment-method-id };
    
	return self.send;
    }

    method from-coinbase() {
	fail 'coinbase deposit requires a coinbase account id' unless $.coinbase-account-id;
	$.path   = 'deposits/coinbase-account';
	$.method = 'POST';
	$.body   = { amount              => $.amount,
		     currency            => $.currency,
		     coinbase_account_id => $.coinbase-account-id };

    return self.send;
    }
}

#|{
=head1 NAME

Finance::GDAX::API::Deposit - Deposit funds via Payment Method or
Coinbase

=head1 SYNOPSIS

  use Finance::GDAX::API::Deposit;

  $deposit = Finance::GDAX::API::Deposit->new(
          currency => 'USD',
          amount   => '250.00');
  $deposit->payment_method_id('kwji-wefwe-ewrgeurg-wef');

  $response = $deposit->from_payment;

  # Or, from a Coinbase account
  $deposit->coinbase_account_id('woifhe-i234h-fwikn-wfihwe');

  $response = $deposit->from_coinbase;

=head2 DESCRIPTION

Used to transfer funds into your GDAX account, either from a
predefined Payment Method or your Coinbase account.

Both methods require the same two attributes: "amount" and "currency"
to be set, along with their corresponding payment or coinbase account
id's.

=head1 ATTRIBUTES

=head2 C<payment_method_id> $string

ID of the payment method.

Either this or coinbase_account_id must be set.

=head2 C<coinbase_account_id> $string

ID of the coinbase account.

Either this or payment_method_id must be set.

=head2 C<amount> $number

The amount to be deposited.

=head2 C<currency> $currency_string

The currency of the amount -- for example "USD".

=head1 METHODS

=head2 C<from_payment>

All attributes must be set before calling this method. The return
value is a hash that will describe the result of the payment.

From the current GDAX API documentation, this is how that returned hash is
keyed:

  {
    "amount": 10.00,
    "currency": "USD",
    "payment_method_id": "bc677162-d934-5f1a-968c-a496b1c1270b"
  }

=head2 C<from_coinbase>

All attributes must be set before calling this method. The return
value is a hash that will describe the result of the funds move.

From the current GDAX API documentation, this is how that returned hash is
keyed:

  {
    "id": "593533d2-ff31-46e0-b22e-ca754147a96a",
    "amount": "10.00",
    "currency": "BTC",
  }

=cut


=head1 AUTHOR

Mark Rushing <mark@orbislumen.net>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2017 by Home Grown Systems, SPC.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

}
