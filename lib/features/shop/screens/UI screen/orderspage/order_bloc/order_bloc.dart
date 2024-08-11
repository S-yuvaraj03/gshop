import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gshop/features/shop/screens/UI%20screen/orderspage/cart_bloc/cart_bloc.dart';

part 'order_event.dart';
part 'order_state.dart';


class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderState([])) {
    on<AddOrder>(_onAddOrder);
  }

  void _onAddOrder(AddOrder event, Emitter<OrderState> emit) {
    final orders = List<Order>.from(state.orders);
    orders.add(Order(items: event.items, totalPrice: event.totalPrice));
    emit(OrderState(orders));
  }
}



