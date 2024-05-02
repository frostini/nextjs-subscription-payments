'use client';

import Link from 'next/link';
import { SignOut } from '@/utils/auth-helpers/server';
import { handleRequest } from '@/utils/auth-helpers/client';
import Logo from '@/components/icons/Logo';
import { usePathname, useRouter } from 'next/navigation';
// import { getRedirectMethod } from '@/utils/auth-helpers/settings';
import s from './Navbar.module.css';

interface NavlinksProps {
    user?: any;
}

export default function Navlinks({ user }: NavlinksProps) {
//   BUG: getting order of hooks error due to conditional user of hook https://stackoverflow.com/questions/57397395/react-has-detected-a-change-in-the-order-of-hooks-but-hooks-seem-to-be-invoked
// commented out the conditional for server/client redirect as it is unnecessary due to flickr bug on server side redirects as specified in /auth-helpers/settings file
// other useful article on conditional hooks: https://www.robinwieruch.de/react-conditional-hooks/
  // const router = getRedirectMethod() === 'client' ? useRouter() : null;  

  const router = useRouter();

  return (
        <div className="relative flex flex-row justify-between py-4 align-center md:py-6">
          <div className="flex items-center flex-1">
            <Link href="/" className={s.logo} aria-label="Logo">
              <Logo />
            </Link>
            <nav className="hidden ml-6 space-x-2 lg:block">
              <Link href="/" className={s.link}>
                Pricing
              </Link>
              {user && (
                <Link href="/account" className={s.link}>
                  Account
                </Link>
              )}
            </nav>
          </div>
          <div className="flex justify-end flex-1 space-x-8">
            {user ? (
              <form onSubmit={(e) => handleRequest(e, SignOut, router)}>
                <input type="hidden" name="pathName" value={usePathname()} />
                <button type='submit' className={s.link}>Sign out</button>
              </form>
            ) : (
              <Link href="/signin" className={s.link}>
                Sign In
              </Link>
            )}
          </div>
        </div>
    );
}