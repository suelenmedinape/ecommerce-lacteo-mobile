package com.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.services.ProducerService;

@RestController
@RequestMapping("/temp")
public class TempController {

	@Autowired
	private ProducerService producerService;

	// rota usada para definir o meta dado do admin como role_admin para permitir o
	// usu do storege, pois a politica diz que apenas 'quem tem a role_admin pode
	// enviar, atualizar, deleta imagens do storege'
	@PutMapping("/set-admin-role/{supabaseId}")
	public ResponseEntity<String> setAdminRole(@PathVariable String supabaseId) {
		try {
			producerService.setAdminRoleInSupabaseAuth(supabaseId);
			return ResponseEntity.ok("Role de admin definida com sucesso para o usuário: " + supabaseId);
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
					.body("Falha ao definir role: " + e.getMessage());
		}
	}
}
