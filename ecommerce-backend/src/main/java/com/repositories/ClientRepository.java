package com.repositories;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.domain.Client;

public interface ClientRepository extends JpaRepository<Client, Long>{

	Client findByEmail(String email);
	
	Optional<Client> findBySupabaseId(UUID supabaseId);
}
