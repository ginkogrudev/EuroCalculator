class CartService {
  List<double> getClientItems() => _clientCart;
  List<double> getBusinessItems() => _businessCart;

  final List<double> _clientCart = [];
  final List<double> _businessCart = [];

  // Use curly braces to enable named parameters: amount and isClient
  void addItem({required double amount, required bool isClient}) {
    if (isClient) {
      _clientCart.add(amount);
    } else {
      _businessCart.add(amount);
    }
  }

  void clearCart({required bool isClient}) {
    if (isClient) {
      _clientCart.clear();
    } else {
      _businessCart.clear();
    }
  }

  double getTotal({required bool isClient}) {
    List<double> activeCart = isClient ? _clientCart : _businessCart;
    return activeCart.fold(0, (sum, item) => sum + item);
  }
}
