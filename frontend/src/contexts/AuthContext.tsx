import { createContext, useContext, useEffect, useMemo, useState, ReactNode, useCallback } from "react";
import {
  apiRequest,
  decodeJwt,
  extractRole,
  extractUserId,
  getToken,
  setToken,
  Role,
  USER_STORAGE_KEY,
} from "@/lib/api";

export interface AuthUser {
  id: string | null;
  userName: string | null;
  role: Role | null;
}

interface LoginInput {
  userName: string;
  password: string;
}

interface AuthContextValue {
  user: AuthUser | null;
  token: string | null;
  role: Role | null;
  isAuthenticated: boolean;
  isReady: boolean;
  login: (input: LoginInput) => Promise<AuthUser>;
  logout: () => void;
}

const AuthContext = createContext<AuthContextValue | undefined>(undefined);

function readStoredUser(): AuthUser | null {
  try {
    const raw = sessionStorage.getItem(USER_STORAGE_KEY);
    return raw ? (JSON.parse(raw) as AuthUser) : null;
  } catch {
    return null;
  }
}

function writeStoredUser(user: AuthUser | null) {
  try {
    if (user) sessionStorage.setItem(USER_STORAGE_KEY, JSON.stringify(user));
    else sessionStorage.removeItem(USER_STORAGE_KEY);
  } catch {
    /* ignore */
  }
}

export function AuthProvider({ children }: { children: ReactNode }) {
  const [token, setTokenState] = useState<string | null>(() => getToken());
  const [user, setUser] = useState<AuthUser | null>(() => readStoredUser());
  const [isReady, setIsReady] = useState(false);

  // On mount: validate token expiry from JWT claims.
  useEffect(() => {
    const t = getToken();
    if (t) {
      const claims = decodeJwt(t);
      if (claims?.exp && claims.exp * 1000 < Date.now()) {
        setToken(null);
        writeStoredUser(null);
        setTokenState(null);
        setUser(null);
      }
    }
    setIsReady(true);
  }, []);

  // React to 401 from any API call.
  useEffect(() => {
    const handler = () => {
      setTokenState(null);
      setUser(null);
      writeStoredUser(null);
    };
    window.addEventListener("auth:expired", handler);
    return () => window.removeEventListener("auth:expired", handler);
  }, []);

  const login = useCallback(async (input: LoginInput): Promise<AuthUser> => {
    const data = await apiRequest<{ token?: string; accessToken?: string; role?: string }>(
      "/api/v1/auth",
      { method: "POST", body: input, auth: false }
    );
    const tk = data?.token || data?.accessToken;
    if (!tk) throw new Error("Login response did not include a token");
    setToken(tk);
    const claims = decodeJwt(tk);
    const u: AuthUser = {
      id: extractUserId(claims),
      userName: input.userName,
      role: extractRole(claims) ?? ((data?.role?.toUpperCase() as Role) || null),
    };
    writeStoredUser(u);
    setTokenState(tk);
    setUser(u);
    return u;
  }, []);

  const logout = useCallback(() => {
    setToken(null);
    writeStoredUser(null);
    setTokenState(null);
    setUser(null);
  }, []);

  const value = useMemo<AuthContextValue>(
    () => ({
      user,
      token,
      role: user?.role ?? null,
      isAuthenticated: Boolean(token),
      isReady,
      login,
      logout,
    }),
    [user, token, isReady, login, logout]
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used within AuthProvider");
  return ctx;
}
