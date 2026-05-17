// Centralized API client for Spring Boot backend.
// Handles ApiResponse envelope, JWT auth, and error normalization.

export const API_BASE_URL =
  (import.meta.env.VITE_API_BASE_URL as string | undefined) ?? "http://localhost:8000";

export const TOKEN_STORAGE_KEY = "auth_token";
export const USER_STORAGE_KEY = "auth_user";

export type Role = "APPLICANT" | "RECRUITER" | "ADMIN";

export interface ApiResponse<T = unknown> {
  message?: string;
  status?: number | string;
  error?: string | null;
  errors?: Record<string, string> | string[] | null;
  data?: T;
}

export class ApiError extends Error {
  status: number;
  errors?: Record<string, string> | string[] | null;
  payload?: ApiResponse<unknown>;
  constructor(message: string, status: number, payload?: ApiResponse<unknown>) {
    super(message);
    this.status = status;
    this.errors = payload?.errors ?? null;
    this.payload = payload;
  }
}

export function getToken(): string | null {
  try {
    return localStorage.getItem(TOKEN_STORAGE_KEY) ?? sessionStorage.getItem(TOKEN_STORAGE_KEY);
  } catch {
    return null;
  }
}

export function setToken(token: string | null) {
  try {
    if (token) {
      localStorage.setItem(TOKEN_STORAGE_KEY, token);
      sessionStorage.setItem(TOKEN_STORAGE_KEY, token);
    } else {
      localStorage.removeItem(TOKEN_STORAGE_KEY);
      sessionStorage.removeItem(TOKEN_STORAGE_KEY);
    }
  } catch {
    /* ignore */
  }
}

interface RequestOptions extends Omit<RequestInit, "body" | "headers"> {
  body?: unknown;
  headers?: Record<string, string>;
  auth?: boolean; // default true
  isForm?: boolean;
}

export async function apiRequest<T = unknown>(
  path: string,
  opts: RequestOptions = {}
): Promise<T> {
  const { body, headers = {}, auth = true, isForm = false, ...rest } = opts;

  const finalHeaders: Record<string, string> = { Accept: "application/json", ...headers };
  if (auth) {
    const token = getToken();
    if (token) finalHeaders.Authorization = `Bearer ${token}`;
  }

  let payload: BodyInit | undefined;
  if (body !== undefined && body !== null) {
    if (isForm && body instanceof FormData) {
      payload = body;
    } else {
      finalHeaders["Content-Type"] = "application/json";
      payload = JSON.stringify(body);
    }
  }

  let res: Response;
  try {
    res = await fetch(`${API_BASE_URL}${path}`, {
      ...rest,
      headers: finalHeaders,
      body: payload,
    });
  } catch (e) {
    throw new ApiError("Network error. Please check your connection.", 0);
  }

  // Auth header from login responses (if present)
  const authHeader = res.headers.get("Authorization") ?? res.headers.get("authorization");

  let json: ApiResponse<T> | null = null;
  const text = await res.text();
  if (text) {
    try {
      json = JSON.parse(text) as ApiResponse<T>;
    } catch {
      json = { message: text } as ApiResponse<T>;
    }
  }

  if (!res.ok) {
    if (res.status === 401) {
      setToken(null);
      try {
        localStorage.removeItem(USER_STORAGE_KEY);
        sessionStorage.removeItem(USER_STORAGE_KEY);
      } catch {
        /* ignore */
      }
      // Soft signal to app to react to expired session
      window.dispatchEvent(new CustomEvent("auth:expired"));
    }
    const msg = json?.message || json?.error || `Request failed (${res.status})`;
    throw new ApiError(msg, res.status, json ?? undefined);
  }

  // Login response: token may be on header OR in body data.token
  const data = (json?.data ?? json) as T & { token?: string };
  if (authHeader && data && typeof data === "object" && !(data as any).token) {
    const headerToken = authHeader.replace(/^Bearer\s+/i, "");
    (data as any).token = headerToken;
  }
  return data;
}

// Minimal JWT decoder (no verification — display/routing only).
export interface JwtClaims {
  sub?: string;
  userId?: string | number;
  id?: string | number;
  role?: Role | string;
  roles?: string[];
  authorities?: string[];
  exp?: number;
}

export function decodeJwt(token: string): JwtClaims | null {
  try {
    const parts = token.split(".");
    if (parts.length < 2) return null;
    const rawPayload = parts.length === 2 ? parts[0] : parts[1];
    const payload = rawPayload.replace(/-/g, "+").replace(/_/g, "/");
    const padded = payload + "===".slice((payload.length + 3) % 4);
    const decoded = atob(padded);
    if (decoded.includes("|")) {
      const [userId, userName, email, roleName, , exp] = decoded.split("|");
      return {
        userId,
        sub: userName,
        role: roleName,
        roles: roleName ? [roleName] : undefined,
        exp: exp ? Number(exp) : undefined,
        email,
      } as JwtClaims & { email?: string };
    }
    return JSON.parse(decoded) as JwtClaims;
  } catch {
    return null;
  }
}

export function extractRole(claims: JwtClaims | null): Role | null {
  if (!claims) return null;
  const candidates: string[] = [];
  if (typeof claims.role === "string") candidates.push(claims.role);
  if (Array.isArray(claims.roles)) candidates.push(...claims.roles);
  if (Array.isArray(claims.authorities)) candidates.push(...claims.authorities);
  for (const raw of candidates) {
    const r = raw.replace(/^ROLE_/i, "").toUpperCase();
    if (r === "APPLICANT" || r === "RECRUITER" || r === "ADMIN") return r as Role;
  }
  return null;
}

export function extractUserId(claims: JwtClaims | null): string | null {
  if (!claims) return null;
  return (
    (claims.userId !== undefined && String(claims.userId)) ||
    (claims.id !== undefined && String(claims.id)) ||
    (claims.sub ? String(claims.sub) : null)
  );
}
