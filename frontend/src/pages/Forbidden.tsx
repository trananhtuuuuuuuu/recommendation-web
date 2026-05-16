import { ShieldAlert, ArrowLeft } from "lucide-react";
import { Button } from "@/components/ui/button";
import { useNavigate } from "react-router-dom";
import type { Role } from "@/lib/api";

export default function Forbidden({ requiredRoles }: { requiredRoles?: Role[] }) {
  const navigate = useNavigate();
  return (
    <div className="max-w-lg mx-auto pt-16 text-center space-y-5">
      <div className="w-16 h-16 rounded-2xl bg-destructive/15 flex items-center justify-center mx-auto">
        <ShieldAlert className="w-8 h-8 text-destructive" />
      </div>
      <div className="space-y-1">
        <h1 className="font-display text-2xl font-bold text-foreground">Authorization denied</h1>
        <p className="text-sm text-muted-foreground">
          You don't have permission to view this page.
          {requiredRoles?.length ? ` Requires role: ${requiredRoles.join(" or ")}.` : ""}
        </p>
      </div>
      <div className="flex justify-center gap-2">
        <Button variant="outline" onClick={() => navigate(-1)} className="gap-1">
          <ArrowLeft className="w-4 h-4" /> Back
        </Button>
        <Button onClick={() => navigate("/")}>Home</Button>
      </div>
    </div>
  );
}
