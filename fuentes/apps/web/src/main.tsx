import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { BrowserRouter } from 'react-router';
import { App } from './App';
import { ProveedorCarrito } from './carrito/carrito';
import './index.css';

const consultas = new QueryClient({ defaultOptions: { queries: { retry: 1, staleTime: 30_000 } } });

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <QueryClientProvider client={consultas}>
      <ProveedorCarrito>
        <BrowserRouter>
          <App />
        </BrowserRouter>
      </ProveedorCarrito>
    </QueryClientProvider>
  </StrictMode>,
);
