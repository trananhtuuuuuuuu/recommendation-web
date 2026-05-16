import { ReactNode } from "react";
import { Navigate, useLocation } from "react-router-dom";
import { useAuth } from "@/contexts/AuthContext";
import type { Role } from "@/lib/api";
import Forbidden from "@/pages/Forbidden";

interface RouteGuardProps {
  children: ReactNode;
  roles?: Role[]; // if omitted, just requires authentication
}

export default function RouteGuard({ children, roles }: RouteGuardProps) {
  const { isAuthenticated, isReady, role } = useAuth();
  const location = useLocation();

  if (!isReady) {
    return (
      <div className="flex items-center justify-center min-h-[60vh] text-sm text-muted-foreground">
        Loading...
      </div>
    );
  }

  if (!isAuthenticated) {
    return <Navigate to="/auth" replace state={{ from: location.pathname }} />;
  }

  if (roles && roles.length > 0 && (!role || !roles.includes(role))) {
    return <Forbidden requiredRoles={roles} />;
  }

  return <>{children}</>;
}
