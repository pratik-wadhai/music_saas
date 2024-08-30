"use client";
import { signIn } from "next-auth/react";
import { useSession } from "next-auth/react";
import { signOut } from "next-auth/react";
export const Appbar = () => {
  const session = useSession();
  return (
    <div className="flex justify-between items-center p-4">
      <div className="text-2xl font-bold">Muzi</div>
      <div>
        {session.data?.user && (
          <button className="bg-blue-500 text-white" onClick={() => signOut()}>
            Logout
          </button>
        )}
        {!session.data?.user && (
          <button className="bg-blue-500 text-white" onClick={() => signIn()}>
            Login
          </button>
        )}
      </div>
    </div>
  );
};
