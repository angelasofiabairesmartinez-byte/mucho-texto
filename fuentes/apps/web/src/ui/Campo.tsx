import { forwardRef, type InputHTMLAttributes } from 'react';

type Props = InputHTMLAttributes<HTMLInputElement> & { etiqueta: string; error?: string };

// Campo de formulario con etiqueta y mensaje de error (para React Hook Form)
export const Campo = forwardRef<HTMLInputElement, Props>(function Campo({ etiqueta, error, id, ...props }, ref) {
  const idCampo = id ?? props.name;
  return (
    <label htmlFor={idCampo} className="block space-y-1">
      <span className="text-sm font-medium">{etiqueta}</span>
      <input
        ref={ref}
        id={idCampo}
        className="w-full rounded-md border border-stone-300 bg-white px-3 py-2 text-sm"
        aria-invalid={!!error}
        {...props}
      />
      {error && <span className="text-sm text-red-700">{error}</span>}
    </label>
  );
});
