import type { Role } from "@/lib/api";

const MAX_AVATAR_BYTES = 1_500_000;

function avatarKey(role: Role, userId: string) {
  return `profile_avatar:${role}:${userId}`;
}

export function readProfileAvatar(role: Role | null, userId?: string | null) {
  if (!role || !userId) return "";
  try {
    return localStorage.getItem(avatarKey(role, userId)) || "";
  } catch {
    return "";
  }
}

export function storeProfileAvatar(role: Role, userId: string, dataUrl: string) {
  try {
    localStorage.setItem(avatarKey(role, userId), dataUrl);
  } catch {
    throw new Error("The browser could not store this image. Try a smaller file.");
  }
}

export function removeProfileAvatar(role: Role, userId: string) {
  try {
    localStorage.removeItem(avatarKey(role, userId));
  } catch {
    /* Local avatar removal should not block the profile UI. */
  }
}

export function avatarFileToDataUrl(file: File) {
  if (!file.type.startsWith("image/")) {
    return Promise.reject(new Error("Please select a valid image file."));
  }
  if (file.size > MAX_AVATAR_BYTES) {
    return Promise.reject(new Error("Avatar images must be smaller than 1.5 MB."));
  }

  return new Promise<string>((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = () => resolve(String(reader.result || ""));
    reader.onerror = () => reject(new Error("Unable to read the selected image."));
    reader.readAsDataURL(file);
  });
}
