package com.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.domain.Client;
import com.dtos.RegisterClientDTO;
import com.services.ClientService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/auth")
public class AuthController {

	@Autowired
	private ClientService clientService;
 
	@PostMapping("/register")
	public ResponseEntity<Map<String, String>> register(@Valid @RequestBody RegisterClientDTO clientDTO) {
		
		Client newClient = new Client();
		newClient.setName(clientDTO.getName());
		newClient.setEmail(clientDTO.getEmail());
		newClient.setSupabaseId(clientDTO.getSupabaseId());
		clientService.register(newClient);

		Map<String, String> response = Map.of("message", "Cadastro realizado com sucesso! Faça login para começar.");
		return ResponseEntity.status(HttpStatus.CREATED).body(response);
	}
}
