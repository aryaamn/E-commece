class Order {
  int totalPrice;
  String address;
  String documentId;
  String status;
  String userid;
  String image;
  Order(
      {this.totalPrice,
      this.address,
      this.documentId,
      this.status,
      this.userid,
      this.image});

  void add(Order orders) {}
}
