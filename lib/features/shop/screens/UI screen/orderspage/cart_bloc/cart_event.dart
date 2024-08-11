part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddItem extends CartEvent {
  final Product product;

  AddItem(this.product);

  @override
  List<Object> get props => [product];
}

class RemoveItem extends CartEvent {
  final Product product;

  RemoveItem(this.product);

  @override
  List<Object> get props => [product];
}

class DeleteItem extends CartEvent {
  final Product product;

  DeleteItem(this.product);

  @override
  List<Object> get props => [product];
}

class CartCleared extends CartEvent {}
