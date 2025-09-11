package com.dtos;

import java.util.UUID;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public class RegisterClientDTO {

	@NotBlank(message = "Nome não pode estar vazio.")
	@Size(min = 4, message = "Nome deve ter pelo menos 4 caracteres.")
	private String name;

	@NotBlank(message = "Email não pode estar vazio.")
	@Email(message = "Email inválido.")
	private String email;

	@NotNull(message = "O Supabase ID é obrigatório.")
	private UUID supabaseId;

	public RegisterClientDTO() {
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public UUID getSupabaseId() {
		return supabaseId;
	}

	public void setSupabaseId(UUID supabaseId) {
		this.supabaseId = supabaseId;
	}
}
