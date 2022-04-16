class CartItem {
  CartItem({
    required this.title,
    required this.cartItemID,
    required this.price,
    required this.productID,
    this.quantity = 0,
  });

  final String cartItemID, title, productID;
  final double price;
  int quantity;
}
