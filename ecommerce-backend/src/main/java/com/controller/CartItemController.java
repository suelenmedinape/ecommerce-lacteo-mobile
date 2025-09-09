package com.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.domain.Cart;
import com.domain.CartItem;
import com.domain.Client;
import com.dtos.CartItemDTO;
import com.services.AuthenticatedUserService;
import com.services.CartService;

@RestController
@RequestMapping("/cart")
@CrossOrigin(origins = "http://localhost:4200")
public class CartItemController {

	@Autowired
	private AuthenticatedUserService authenticatedUserService;
	
	@Autowired
	private CartService cartService;
	
	@PostMapping("/add")
	public ResponseEntity<Void> addItemToCart(@RequestBody CartItemDTO cartItemDTO){
		Client client = (Client) authenticatedUserService.getCurrentClient();
		cartService.addItemToCart(client.getId(), cartItemDTO.getProductId(), cartItemDTO.getQuantity());		
		
		return ResponseEntity.ok().build();
	}
	
	@GetMapping
	public ResponseEntity<List<CartItem>> listCartItems(){
		Client client = (Client) authenticatedUserService.getCurrentClient();
		
		Cart cart = cartService.findByClientId(client.getCart().getId());
		
		return ResponseEntity.ok(cart.getCartItems());
	}
	
	@DeleteMapping("/{productId}")
	public ResponseEntity<Void> removeItemFromCart( @PathVariable Long productId){
		Client client = (Client) authenticatedUserService.getCurrentClient();
		
		cartService.removeProductByCartItems(client.getCart().getId(), productId);
	
		return ResponseEntity.ok().build();
	}

	@PutMapping("/update")
	public ResponseEntity<Void> updateItemFromCart(@RequestBody CartItemDTO cartItemDTO){
		Client client = (Client) authenticatedUserService.getCurrentClient();
		cartService.addItemToCart(client.getId(), cartItemDTO.getProductId(), cartItemDTO.getQuantity());		
		
		return ResponseEntity.ok().build();
	}
	
	@PostMapping("/buy")
	 public ResponseEntity<Void> buyItemsCart() {
		Client client = (Client) authenticatedUserService.getCurrentClient();
		
		cartService.buyItemsFromCart(client.getCart().getId());
        return ResponseEntity.ok().build();
    }
}
