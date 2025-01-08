class CheckoutSessionResponse {
  final String sessionId;
  final String url;

  CheckoutSessionResponse({required this.sessionId, required this.url});

  factory CheckoutSessionResponse.fromJson(Map<String, dynamic> json) {
    return CheckoutSessionResponse(
      sessionId: json['sessionId'],
      url: json['url'],
    );
  }
}
