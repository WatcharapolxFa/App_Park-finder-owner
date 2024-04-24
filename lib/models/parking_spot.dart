class ParkingSpot {
  final String parkingID;
  final String parkingName;
  final Map address;
  final bool isOpen;
  final int price;
  final String parkingPictureUrl;
  final Map openDetail;
  final String statusApply;
  final String statusApplyDetail;
  final List review;

  ParkingSpot({
    required this.parkingID,
    required this.parkingName,
    required this.address,
    required this.price,
    required this.parkingPictureUrl,
    required this.isOpen,
    required this.openDetail,
    required this.statusApply,
    required this.statusApplyDetail,
    required this.review,
  });

  factory ParkingSpot.fromJson(Map<String, dynamic> json) {
    return ParkingSpot(
      parkingID: json['_id'],
      parkingName: json['parking_name'],
      address: json['address'],
      price: json['price'],
      parkingPictureUrl: json['parking_picture_url'],
      isOpen: json['open_status'],
      openDetail: json['open_detail'],
      statusApply: json['status_apply'],
      statusApplyDetail: json['status_apply_description'],
      review: json['review'],
    );
  }
  Map<String, String> toMap() {
    return {
      'id': parkingID,
      'name': parkingName,
    };
  }
}
