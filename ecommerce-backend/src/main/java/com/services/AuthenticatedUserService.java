package com.services;

import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.stereotype.Component;

import com.domain.Person;
import com.exceptions.ClientNotFoundException;
import com.repositories.ClientRepository;

@Component
public class AuthenticatedUserService {

    @Autowired
    private ClientRepository clientRepository;

    public Person getCurrentClient() {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (principal instanceof Jwt) {
            Jwt jwt = (Jwt) principal;
            String supabaseIdStr = jwt.getSubject();
            UUID supabaseId = UUID.fromString(supabaseIdStr);
            
            return clientRepository.findBySupabaseId(supabaseId)
                    .orElseThrow(() -> new ClientNotFoundException("Cliente autenticado não encontrado no banco de dados com ID: " + supabaseId));
        } else {
            throw new IllegalStateException("O principal de autenticação não é uma instância de JWT.");
        }
    }
}