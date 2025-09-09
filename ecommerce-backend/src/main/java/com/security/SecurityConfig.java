package com.security;

import com.domain.Client;
import com.domain.Person;
import com.domain.Producer;
import com.repositories.ClientRepository;
import com.repositories.ProducerRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationConverter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

import java.util.Collections;
import java.util.Optional;
import java.util.UUID;

import static org.springframework.security.config.Customizer.withDefaults;


@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    private ClientRepository clientRepository;
    
    @Autowired
    private ProducerRepository producerRepository;

    @Bean
    SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        return http
                .csrf(csrf -> csrf.disable()).cors(withDefaults())
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/h2-console/**").permitAll()
                        .requestMatchers(HttpMethod.POST, "/auth/register").permitAll()
                        .requestMatchers(HttpMethod.POST, "/auth/login").permitAll()
                        .requestMatchers(HttpMethod.GET, "/products", "/products/{id}", "/products/search", "/products/list").permitAll()
                        .requestMatchers(HttpMethod.GET, "/list-categories").permitAll()
                        .requestMatchers(HttpMethod.GET, "/dashboard/products/best-sellers").permitAll()
                        
                        .requestMatchers(HttpMethod.POST, "/products").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.PUT, "/products/{productId}").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/products/{productId}").hasRole("ADMIN")
                        .requestMatchers("/orders/**", "/dashboard/**").hasRole("ADMIN")
                        .requestMatchers("/my/**", "/cart/**").hasRole("CLIENT")
                        
                        .anyRequest().authenticated()
                )
                .oauth2ResourceServer(oauth2 -> oauth2.jwt(jwt -> jwt.jwtAuthenticationConverter(jwtAuthenticationConverter())))
                .headers(headers -> headers.frameOptions().sameOrigin())
                .build();
    }

    private JwtAuthenticationConverter jwtAuthenticationConverter() {
        JwtAuthenticationConverter converter = new JwtAuthenticationConverter();
        
        converter.setJwtGrantedAuthoritiesConverter(jwt -> {
            String supabaseIdStr = jwt.getClaimAsString("sub");
            if (supabaseIdStr == null) {
                return Collections.emptyList();
            }

            UUID supabaseId = UUID.fromString(supabaseIdStr);

            Optional<Client> clientOptional = clientRepository.findBySupabaseId(supabaseId);
            
            if (clientOptional.isPresent()) {
                Person client = clientOptional.get();
                String roleName = client.getRole().name(); 
                                
                GrantedAuthority authority = new SimpleGrantedAuthority(roleName);
                return Collections.singletonList(authority);
            }

            Optional<Producer> producerOptional = producerRepository.findBySupabaseId(supabaseId);
            
            if (producerOptional.isPresent()) {
                Person producer = producerOptional.get();
                String roleName = producer.getRole().name(); 
                                
                GrantedAuthority authority = new SimpleGrantedAuthority(roleName);
                return Collections.singletonList(authority);
            }
            
            return Collections.emptyList();
        });

        return converter;
    }

    @Bean
    PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}