class SearchScreenModel {
  bool? success;
  int? count;
  List<Products>? products;

  SearchScreenModel({this.success, this.count, this.products});

  SearchScreenModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    count = json['count'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['count'] = this.count;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  String? sId;
  String? name;
  String? shortDescription;
  String? longDescription;
  String? material;
  List<String>? isSafeFor;
  String? usageInstructions;
  TechnicalSpecifications? technicalSpecifications;
  List<String>? certifications;
  String? warranty;
  int? price;
  int? stock;
  String? category;
  List<String>? tags;
  String? image;
  List<String>? additionalImages;
  Shop? shop;
  List<Offers>? offers;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? expiryDate;

  Products(
      {this.sId,
      this.name,
      this.shortDescription,
      this.longDescription,
      this.material,
      this.isSafeFor,
      this.usageInstructions,
      this.technicalSpecifications,
      this.certifications,
      this.warranty,
      this.price,
      this.stock,
      this.category,
      this.tags,
      this.image,
      this.additionalImages,
      this.shop,
      this.offers,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.expiryDate});

  Products.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    shortDescription = json['shortDescription'];
    longDescription = json['longDescription'];
    material = json['material'];
    isSafeFor = json['isSafeFor'].cast<String>();
    usageInstructions = json['usageInstructions'];
    technicalSpecifications = json['technicalSpecifications'] != null
        ? new TechnicalSpecifications.fromJson(json['technicalSpecifications'])
        : null;
    certifications = json['certifications'].cast<String>();
    warranty = json['warranty'];
    price = json['price'];
    stock = json['stock'];
    category = json['category'];
    tags = json['tags'].cast<String>();
    image = json['image'];
    additionalImages = json['additionalImages'].cast<String>();
    shop = json['shop'] != null ? new Shop.fromJson(json['shop']) : null;
    if (json['offers'] != null) {
      offers = <Offers>[];
      json['offers'].forEach((v) {
        offers!.add(new Offers.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    expiryDate = json['expiryDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['shortDescription'] = this.shortDescription;
    data['longDescription'] = this.longDescription;
    data['material'] = this.material;
    data['isSafeFor'] = this.isSafeFor;
    data['usageInstructions'] = this.usageInstructions;
    if (this.technicalSpecifications != null) {
      data['technicalSpecifications'] = this.technicalSpecifications!.toJson();
    }
    data['certifications'] = this.certifications;
    data['warranty'] = this.warranty;
    data['price'] = this.price;
    data['stock'] = this.stock;
    data['category'] = this.category;
    data['tags'] = this.tags;
    data['image'] = this.image;
    data['additionalImages'] = this.additionalImages;
    if (this.shop != null) {
      data['shop'] = this.shop!.toJson();
    }
    if (this.offers != null) {
      data['offers'] = this.offers!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['expiryDate'] = this.expiryDate;
    return data;
  }
}

class TechnicalSpecifications {
  String? weight;
  String? dimensions;
  String? color;
  String? power;
  String? voltage;

  TechnicalSpecifications(
      {this.weight, this.dimensions, this.color, this.power, this.voltage});

  TechnicalSpecifications.fromJson(Map<String, dynamic> json) {
    weight = json['weight'];
    dimensions = json['dimensions'];
    color = json['color'];
    power = json['power'];
    voltage = json['voltage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['weight'] = this.weight;
    data['dimensions'] = this.dimensions;
    data['color'] = this.color;
    data['power'] = this.power;
    data['voltage'] = this.voltage;
    return data;
  }
}

class Shop {
  String? sId;
  String? name;

  Shop({this.sId, this.name});

  Shop.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}

class Offers {
  String? type;
  int? value;
  int? minPurchaseAmount;
  String? validTill;
  String? sId;

  Offers(
      {this.type,
      this.value,
      this.minPurchaseAmount,
      this.validTill,
      this.sId});

  Offers.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = json['value'];
    minPurchaseAmount = json['minPurchaseAmount'];
    validTill = json['validTill'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['value'] = this.value;
    data['minPurchaseAmount'] = this.minPurchaseAmount;
    data['validTill'] = this.validTill;
    data['_id'] = this.sId;
    return data;
  }
}
