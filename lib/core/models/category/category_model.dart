import 'package:restaurantapp/core/models/api/api_result.mode.dart';

class CategoryModel extends Serializable {
  final String name;
  CategoryModel({
    required this.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      CategoryModel(name: json['name'] ?? "");

  @override
  Map<String, dynamic> toJson() => {"name": name};
}
