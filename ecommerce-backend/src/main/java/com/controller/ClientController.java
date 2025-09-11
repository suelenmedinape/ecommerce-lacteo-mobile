package com.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.domain.Client;
import com.domain.OrderItem;
import com.dtos.ClientUpdateDTO;
import com.dtos.GetClientDetailsDTO;
import com.dtos.OrderDTO;
import com.enums.OrderStatus;
import com.services.AuthenticatedUserService;
import com.services.ClientService;
import com.services.OrderService;

@RestController
@RequestMapping("/my")
public class ClientController {

	@Autowired
    private AuthenticatedUserService authenticatedUserService;
	
	@Autowired
	private ClientService clientService;
	
	@Autowired 
	private OrderService orderService;
	
	@GetMapping("/profile") 
	public ResponseEntity<GetClientDetailsDTO> getClientDetails(){
		Client client = (Client) authenticatedUserService.getCurrentClient();

		GetClientDetailsDTO dto = new GetClientDetailsDTO(client);
		
		return ResponseEntity.ok(dto);
	}
	
	@PutMapping("/details") 
	public ResponseEntity<Void> updateDetailsClient(@RequestBody ClientUpdateDTO clientUpdateDTO) {		
		Client client = (Client) authenticatedUserService.getCurrentClient();

		clientService.updateClient(client.getId(), clientUpdateDTO);	
	    return ResponseEntity.ok().build();
	}
	
	
	@GetMapping("/orders") 
	public ResponseEntity<List<OrderDTO>> listAllOrders(){
		Client client = (Client) authenticatedUserService.getCurrentClient();	
		
		return ResponseEntity.ok(clientService.listAllOrdersByClient(client.getId()));
	}
	
	/*
	 * verificar esses metodos abaixo, pois parece que esta faltando algo
	 */
	
	@GetMapping("/orders/details/{orderId}")
	public ResponseEntity<List<OrderItem>> listOrderDetails(@PathVariable Long orderId){
		
		return ResponseEntity.ok(clientService.listOrderDetailsByClient(orderId));
	}
	
	@PutMapping("/orders/remove/{orderId}")
	public ResponseEntity<Void> cancelOrder(@PathVariable Long orderId){
		orderService.updateOrderStatus(orderId, OrderStatus.CANCELADO.name());
		
		return ResponseEntity.ok().build();
	}

}
