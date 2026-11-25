import type { ButtonHTMLAttributes } from 'react';

export function Boton({ className = '', ...props }: ButtonHTMLAttributes<HTMLButtonElement>) {
  return (
    <button
      className={`rounded-md bg-stone-900 px-4 py-2 text-sm font-medium text-white hover:bg-stone-700 disabled:opacity-50 ${className}`}
      {...props}
    />
  );
}
