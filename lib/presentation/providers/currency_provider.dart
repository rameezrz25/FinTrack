import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

enum Currency { usd, inr }

class CurrencyState {
  final Currency currency;
  final double exchangeRate; // 1 USD to Target

  const CurrencyState(this.currency, this.exchangeRate);
}

class CurrencyNotifier extends StateNotifier<CurrencyState> {
  CurrencyNotifier() : super(const CurrencyState(Currency.usd, 1.0));

  void toggleCurrency() {
    if (state.currency == Currency.usd) {
      state = const CurrencyState(Currency.inr, 85.0); // Mock rate: 1 USD = 85 INR
    } else {
      state = const CurrencyState(Currency.usd, 1.0);
    }
  }
}

final currencyProvider = StateNotifierProvider<CurrencyNotifier, CurrencyState>((ref) {
  return CurrencyNotifier();
});

// Helper extension to format values
extension CurrencyFormatter on double {
  String toCurrency(CurrencyState state) {
    final value = this * state.exchangeRate;
    final symbol = state.currency == Currency.usd ? '\$' : '₹';
    
    // Use rigid formatting for clearer display
    final formatter = NumberFormat.currency(symbol: symbol, decimalDigits: 2);
    return formatter.format(value);
  }
}
