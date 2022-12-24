

class SalesOrderDetail{
  late final int?
      id,
      sales_order_id,
      product_id,
      customer_complimentary_id,
      asset_type_id,
      asset_id,
      room_id,
      has_term,
      has_quantity,
      length_of_term,
      quantity,
      total_use_of_complimentary,
      cost,
      price,
      discount,
      service_charge,
      tax;

  late final String? name,type,term;
  late final DateTime? started_at,ended_at;

  SalesOrderDetail(
      this.id,
      this.sales_order_id,
      this.product_id,
      this.customer_complimentary_id,
      this.asset_type_id,
      this.asset_id,
      this.room_id,
      this.name,
      this.type,
      this.has_term,
      this.has_quantity,
      this.term,
      this.started_at,
      this.ended_at,
      this.length_of_term,
      this.quantity,
      this.total_use_of_complimentary,
      this.cost,
      this.price,
      this.discount,
      this.service_charge,
      this.tax
      );

  SalesOrderDetail.fromJson(Map<String, dynamic> json){
    id = json['id'];
    sales_order_id = json['sales_order_id'];
    product_id = json['product_id'];
    customer_complimentary_id = json['customer_complimentary_id'];
    asset_type_id = json['asset_type_id'];
    asset_id = json['asset_id'];
    room_id = json['room_id'];
    name = json['name'];
    type = json['type'];
    has_term = json['has_term'];
    has_quantity = json['has_quantity'];
    term = json['term'];
    started_at = json['started_at'];
    length_of_term = json['length_of_term'];
    quantity = json['quantity'];
    total_use_of_complimentary = json['total_use_of_complimentary'];
    cost = 0;
    price = json['price'];
    discount = json['discount'];
    service_charge = json['service_charge'];
    tax = json['tax'];
  }

  SalesOrderDetail.fromMap(Map<dynamic, dynamic> data)
      : id = data['id'],
        sales_order_id = data['sales_order_id'],
        product_id = data['product_id'],
        customer_complimentary_id = data['customer_complimentary_id'],
        asset_type_id = data['asset_type_id'],
        asset_id =data['asset_id'],
        room_id = data['room_id'],
        name = data['name'],
        type = data['type'],
        has_term = data['has_term'],
        has_quantity = data['has_quantity'],
        term = data['term'],
        started_at = data['started_at'],
        ended_at = data['ended_at'],
        length_of_term = data['length_of_term'],
        quantity = data['quantity'],
        total_use_of_complimentary = data['total_use_of_complimentary'],
        cost = data['cost'],
        price = data['price'],
        discount = data['discount'],
        service_charge = data['service_charge'],
        tax = data['tax'];

    Map<String, dynamic> toMap() {
      return {
        'id': id,
        'sales_order_id': sales_order_id,
        'product_id': product_id,
        'customer_complimentary_id': customer_complimentary_id,
        'asset_type_id': asset_type_id,
        'asset_id': asset_id,
        'room_id': room_id,
        'name': name,
        'type': type,
        'has_term': has_term,
        'has_quantity': has_quantity,
        'term': term,
        'started_at': started_at,
        'ended_at': ended_at,
        'length_of_term': length_of_term,
        'quantity': quantity,
        'total_use_of_complimentary': total_use_of_complimentary,
        'cost': cost,
        'price': price,
        'discount': discount,
        'service_charge': service_charge,
        'tax': tax
      };
    }

  Map<String, dynamic> quantityMap() {
    return {
      'product_id': product_id,
      'quantity': quantity,
    };
  }
}